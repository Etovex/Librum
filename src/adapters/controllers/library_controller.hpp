#pragma once
#include <QImage>
#include <QObject>
#include <QString>
#include "adapters_export.hpp"
#include "book_dto.hpp"
#include "book_title_model.hpp"
#include "i_library_controller.hpp"
#include "i_library_service.hpp"
#include "library_model.hpp"

namespace adapters::controllers
{

class ADAPTERS_EXPORT LibraryController : public ILibraryController
{
    Q_OBJECT

public:
    LibraryController(application::ILibraryService* bookService);

    int addBook(const QString& path, bool allowDuplicates = false,
                int projectGutenbergId = 0) override;
    int deleteBook(const QString& uuid) override;
    int deleteAllBooks() override;
    int uninstallBook(const QString& uuid) override;
    int downloadBookMedia(const QString& uuid) override;
    int updateBook(const QString& uuid, const QVariant& operations) override;
    int changeBookCover(const QString& uuid, const QString& path) override;
    int addTag(const QString& bookUuid, const QString& tagName,
               const QString& tagUuid) override;
    void removeAllTagsWithUuid(const QString& tagUuid) override;
    void renameTags(const QString& oldName, const QString& newName) override;
    int removeTag(const QString& bookUuid, const QString& tagUuid) override;
    dtos::BookDto getBook(const QString& uuid) override;
    int getBookCount() const override;
    bool isSyncing() const override;
    void removeAllBooksFromFolderWithId(const QString& folderId) override;

    void syncWithServer() override;
    int saveBookToFile(const QString& uuid, const QUrl& path) override;
    data_models::LibraryProxyModel* getLibraryModel() override;
    data_models::BookTitleProxyModel* getBookTitleModel() override;

public slots:
    void refreshLastOpenedFlag(const QString& uuid) override;

private:
    dtos::BookDto getDtoFromBook(const domain::entities::Book& book);
    QUuid getTagUuidByName(const domain::entities::Book& book,
                           const QString& name);
    void addBookMetaDataToDto(const domain::entities::Book& book,
                              dtos::BookDto& bookDto);
    void addBookTagsToDto(const domain::entities::Book& book,
                          dtos::BookDto& bookDto);
    bool listContainsTag(const QList<domain::entities::Tag>& tags, QUuid uuid);

    application::ILibraryService* m_libraryService;
    data_models::LibraryModel m_libraryModel;
    data_models::LibraryProxyModel m_libraryProxyModel;
    data_models::BookTitleModel m_bookTitleModel;
    data_models::BookTitleProxyModel m_bookTitleProxyModel;
    bool m_currentlySyncing = false;
};

}  // namespace adapters::controllers
