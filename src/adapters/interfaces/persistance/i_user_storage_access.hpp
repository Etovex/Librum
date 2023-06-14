#pragma once
#include <QImage>
#include <QJsonArray>
#include <QJsonObject>
#include <QObject>
#include <QString>

namespace adapters
{

/**
 * The UserStorageAccess class makes the API calls to the user storage server.
 */
class IUserStorageAccess : public QObject
{
    Q_OBJECT

public:
    virtual ~IUserStorageAccess() noexcept = default;

    virtual void getUser(const QString& authToken) = 0;
    virtual void getProfilePicture(const QString& authToken) = 0;
    virtual void changeFirstName(const QString& authToken,
                                 const QString& newFirstName) = 0;
    virtual void changeLastName(const QString& authToken,
                                const QString& newLastName) = 0;
    virtual void changeEmail(const QString& authToken,
                             const QString& newEmail) = 0;
    virtual void changeProfilePicture(const QString& authToken,
                                      const QString& path) = 0;
    virtual void deleteTag(const QString& authToken, const QString& uuid) = 0;
    virtual void renameTag(const QString& authToken,
                           const QJsonObject& bookForUpdate) = 0;

signals:
    void userReady(const QString& firstName, const QString& lastName,
                   const QString& email, long usedBookStorage,
                   long bookStorageLimit, const QJsonArray& tags);
    void gettingUserFailed();
    void profilePictureReady(QByteArray& data);
};

}  // namespace adapters
