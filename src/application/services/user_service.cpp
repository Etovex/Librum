#include "user_service.hpp"
#include <QBuffer>
#include <QDebug>
#include <QImageReader>
#include "automatic_login_helper.hpp"
#include "tag.hpp"

using domain::entities::Tag;
using domain::entities::User;

namespace application::services
{

UserService::UserService(IUserStorageGateway* userStorageGateway) :
    m_userStorageGateway(userStorageGateway),
    m_user("x", "y", "z", 0, 0)
{
    connect(m_userStorageGateway, &IUserStorageGateway::finishedGettingUser,
            this, &UserService::proccessUserInformation);

    connect(m_userStorageGateway, &IUserStorageGateway::profilePictureReady,
            this, &UserService::saveProfilePictureToFile);

    // Tag insertion
    connect(&m_user, &User::tagInsertionStarted, this,
            &UserService::tagInsertionStarted);
    connect(&m_user, &User::tagInsertionEnded, this,
            &UserService::tagInsertionEnded);

    // Tag deletion
    connect(&m_user, &User::tagDeletionStarted, this,
            &UserService::tagDeletionStarted);
    connect(&m_user, &User::tagDeletionEnded, this,
            &UserService::tagDeletionEnded);

    // Tag changed
    connect(&m_user, &User::tagsChanged, this, &UserService::tagsChanged);


    // The timer which controls in which intervall we will check for new changes
    // to the user data on the server.
    m_fetchChangesTimer.setInterval(m_fetchChangesInverval);
    connect(&m_fetchChangesTimer, &QTimer::timeout, this,
            [this]()
            {
                m_userStorageGateway->getUser(m_authenticationToken);
                m_userStorageGateway->getProfilePicture(m_authenticationToken);
            });
}

void UserService::loadUser(bool rememberUser)
{
    auto success = tryLoadingUserFromFile();
    if(!success)
    {
        // Load user from server
        m_rememberUser = rememberUser;
        m_userStorageGateway->getUser(m_authenticationToken);
        return;
    }

    // If the user was loaded from file, we know that "rememberUser" is true
    m_rememberUser = true;

    // Load the user a few milliseconds after the user was loaded from the
    // file to update the local data with the freshest data from the server.
    // Add a delay of a few milliseconds because else we create a segfault.
    QTimer* timer = new QTimer;
    timer->setInterval(100);
    connect(timer, &QTimer::timeout, this,
            [this]()
            {
                m_userStorageGateway->getUser(m_authenticationToken);

                // Free the timer's memory
                auto reply = qobject_cast<QTimer*>(sender());
                reply->deleteLater();
            });
    timer->start();
}

QString UserService::getFirstName() const
{
    return m_user.getFirstName();
}

void UserService::setFirstName(const QString& newFirstName)
{
    m_user.setFirstName(newFirstName);
    m_userStorageGateway->changeFirstName(m_authenticationToken,
                                          m_user.getFirstName());
}

QString UserService::getLastName() const
{
    return m_user.getLastName();
}

void UserService::setLastName(const QString& newLastName)
{
    m_user.setLastName(newLastName);
    m_userStorageGateway->changeLastName(m_authenticationToken,
                                         m_user.getLastName());
}

QString UserService::getEmail() const
{
    return m_user.getEmail();
}

void UserService::setEmail(const QString& newEmail)
{
    m_user.setEmail(newEmail);
    m_userStorageGateway->changeEmail(m_authenticationToken, m_user.getEmail());
}

long UserService::getUsedBookStorage() const
{
    return m_user.getUsedBookStorage();
}

long UserService::getBookStorageLimit() const
{
    return m_user.getBookStorageLimit();
}

QImage UserService::getProfilePicture() const
{
    return m_user.getProfilePicture();
}

void UserService::setProfilePicture(const QString& path, const QImage& image)
{
    if(image == m_user.getProfilePicture())
        return;

    m_user.setProfilePicture(image);
    m_userStorageGateway->changeProfilePicture(m_authenticationToken, path);
}

void UserService::saveProfilePictureToFile(QByteArray& data)
{
    auto userDir = getUserProfileDir();
    auto imageFormat = getImageFormat(data);
    auto destination = userDir.path() + "/profilePicture." + imageFormat;

    QFile file(destination);
    if(!file.open(QIODevice::WriteOnly))
    {
        qWarning() << "Could not open downloaded profile picture";
        return;
    }

    file.write(data);

    // Manually close to make sure the data is written to file before continuing
    file.close();
}

QString UserService::getImageFormat(QByteArray& image) const
{
    QBuffer buffer(&image);
    buffer.open(QIODevice::ReadOnly);

    QImageReader imageReader(&buffer);
    QString format = imageReader.format();
    buffer.close();
    if(format.isEmpty())
    {
        qWarning()
            << "Failed reading the format of the downloaded profile picture";
        return "";
    }

    return format;
}

const std::vector<domain::entities::Tag>& UserService::getTags() const
{
    return m_user.getTags();
}

QUuid UserService::addTag(const domain::entities::Tag& tag)
{
    auto success = m_user.addTag(tag);
    if(!success)
    {
        qWarning() << QString("Failed adding tag with name: %1 to user.")
                          .arg(tag.getName());
        return QUuid();
    }

    return tag.getUuid();
}

bool UserService::deleteTag(const QUuid& uuid)
{
    auto success = m_user.deleteTag(uuid);
    if(!success)
    {
        qWarning() << QString("Failed deleting tag with uuid: %1 from user.")
                          .arg(uuid.toString());
        return false;
    }

    m_userStorageGateway->deleteTag(m_authenticationToken, uuid);
    return true;
}

bool UserService::renameTag(const QUuid& uuid, const QString& newName)
{
    auto success = m_user.renameTag(uuid, newName);
    if(!success)
    {
        qWarning() << QString("Failed renaming tag with uuid: %1 with new "
                              "name: %2 from user.")
                          .arg(uuid.toString(), newName);
        return false;
    }

    m_userStorageGateway->renameTag(m_authenticationToken, uuid,
                                    m_user.getTagByUuid(uuid)->getName());
    return true;
}

void UserService::proccessUserInformation(const domain::entities::User& user,
                                          bool success)
{
    // Avoid storing data for logged out users by verifying login status before
    // applying data, else their data might be in memory even though logged out.
    if(!userIsLoggedIn() || !success)
    {
        emit finishedLoadingUser(false);
        return;
    }

    m_user.setFirstName(user.getFirstName());
    m_user.setLastName(user.getLastName());
    m_user.setEmail(user.getEmail());
    m_user.setUsedBookStorage(user.getUsedBookStorage());
    m_user.setBookStorageLimit(user.getBookStorageLimit());
    for(const auto& tag : user.getTags())
        m_user.addTag(tag);

    emit finishedLoadingUser(true);
    emit bookStorageDataUpdated(user.getUsedBookStorage(),
                                user.getBookStorageLimit());

    // If "rememberUser" is true, update the saved autologin user data everytime
    // there are changes to the user. This way, when logging in via autologin
    // the next time, you already have the newest changes available.
    if(m_rememberUser)
        saveUserToFile(user);
}

bool UserService::userIsLoggedIn()
{
    return !m_authenticationToken.isEmpty();
}

bool UserService::tryLoadingUserFromFile()
{
    auto result = utility::AutomaticLoginHelper::tryAutomaticUserLoading();
    if(result.has_value())
    {
        utility::UserData userData = result.value();
        User user(userData.firstName, userData.lastName, userData.email,
                  userData.usedBookStorage, userData.bookStorageLimit);
        for(auto& tag : userData.tags)
            user.addTag(tag);

        proccessUserInformation(user, true);
        return true;
    }

    return false;
}

void UserService::saveUserToFile(const domain::entities::User& user)
{
    utility::UserData userData {
        user.getFirstName(),       user.getLastName(),         user.getEmail(),
        user.getUsedBookStorage(), user.getBookStorageLimit(), user.getTags(),
    };

    utility::AutomaticLoginHelper::saveUserData(userData);
}

void UserService::setupUserData(const QString& token, const QString& email)
{
    Q_UNUSED(email);
    m_authenticationToken = token;

    m_fetchChangesTimer.start();
}

void UserService::clearUserData()
{
    m_fetchChangesTimer.stop();
    m_user.clearData();
    m_authenticationToken.clear();
    m_rememberUser = false;
}

QDir UserService::getUserProfileDir() const
{
    auto applicationDir = QDir::current().path();
    auto userProfileHash = QString::number(qHash(m_user.getEmail()));
    auto folder = QDir(applicationDir + "/userProfiles/" + userProfileHash);

    if(!folder.exists())
        folder.mkpath(folder.path());

    return folder;
}

}  // namespace application::services
