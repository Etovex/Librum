#pragma once
#include <QObject>
#include <QPixmap>
#include <QString>
#include <QUuid>
#include <optional>
#include <vector>
#include "book.hpp"
#include "book_for_deletion.hpp"

namespace application
{

/**
 * The BookStorageManager manages the book storage for the local and remote
 * library.
 */
class IBookStorageManager : public QObject
{
    Q_OBJECT

public:
    virtual ~IBookStorageManager() noexcept = default;

    virtual void addBook(const domain::entities::Book& bookToAdd) = 0;
    virtual void addBookLocally(const domain::entities::Book& bookToAdd) = 0;
    virtual void deleteBook(utility::BookForDeletion bookToDelete) = 0;
    virtual void uninstallBook(const domain::entities::Book& book) = 0;
    virtual void downloadBookMedia(const QUuid& uuid) = 0;
    virtual void updateBook(const domain::entities::Book& book) = 0;
    virtual void updateBookLocally(const domain::entities::Book& book) = 0;
    virtual void updateBookRemotely(const domain::entities::Book& book) = 0;
    virtual void updateBookCoverRemotely(const QUuid& uuid, bool hasCover) = 0;
    virtual std::optional<QString> saveBookCoverToFile(
        const QUuid& uuid, const QPixmap& cover) = 0;
    virtual bool deleteBookCoverLocally(const QUuid& uuid) = 0;
    virtual void downloadBookCover(const QUuid& uuid) = 0;
    virtual std::vector<domain::entities::Book> loadLocalBooks() = 0;
    virtual void downloadRemoteBooks() = 0;

    virtual void setUserData(const QString& email,
                             const QString& authToken) = 0;
    virtual void clearUserData() = 0;

signals:
    void finishedDownloadingRemoteBooks(
        std::vector<domain::entities::Book>& books);
    void downloadingBookMediaProgressChanged(const QUuid& uuid,
                                             qint64 bytesReceived,
                                             qint64 bytesTotal);
    void finishedDownloadingBookMedia(const QUuid& uuid,
                                      const QString& filePath);
    void finishedDownloadingBookCover(const QUuid& uuid,
                                      const QString& filePath);
    void storageLimitExceeded();
};

}  // namespace application
