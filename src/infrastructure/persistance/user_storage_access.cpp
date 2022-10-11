#include "user_storage_access.hpp"

namespace infrastructure::persistence
{

UserStorageAccess::UserStorageAccess()
    : m_getUserEndpoint("https://localhost:7084/api/user")
{
}

void UserStorageAccess::getUser(const QString& authenticationToken)
{
    auto request = createRequest(m_getUserEndpoint, authenticationToken);
    
    m_reply.reset(m_networkAccessManager.get(request));
    
    QObject::connect(m_reply.get(), &QNetworkReply::finished, 
                     this, &UserStorageAccess::proccessGetUserResult);
}

void UserStorageAccess::proccessGetUserResult()
{
    int expectedStatusCode = 200;
    if(checkForErrors(expectedStatusCode))
    {
        emit gettingUserFailed();
        return;
    }
    
    emit userReady("placeHolder", "placeHolder", "placeHolder");
}

QNetworkRequest UserStorageAccess::createRequest(const QUrl& url, 
                                                 const QString& authToken)
{
    QNetworkRequest result{ url };
    result.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    result.setRawHeader("X-Version", "1.0");
    result.setRawHeader(QByteArray("Authorization"), "Bearer " + authToken.toUtf8());
        
    QSslConfiguration sslConfiguration = result.sslConfiguration();
    sslConfiguration.setProtocol(QSsl::AnyProtocol);
    sslConfiguration.setPeerVerifyMode(QSslSocket::QueryPeer);
    result.setSslConfiguration(sslConfiguration);
    
    return result;
}

bool UserStorageAccess::checkForErrors(int expectedStatusCode)
{
    if(m_reply->error() != QNetworkReply::NoError)
    {
        qDebug() << "there was an error! " << m_reply->errorString();
    }
    
    int statusCode = m_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if(statusCode != expectedStatusCode)
    {
        qDebug() << "there was an error! " << m_reply->readAll();
        return true;
    }
    
    return false;
}

} // namespace infrastructure::persistence