#pragma once
#include <memory>
#include "book.hpp"
#include "i_book_service.hpp"
#include "i_library_service.hpp"
#include "mupdf/classes.h"
#include "toc/filtered_toc_model.hpp"
#include "utils/book_searcher.hpp"

namespace application::services
{

class BookService : public IBookService
{
public:
    BookService(ILibraryService* libraryService);

    void setUp(QUuid uuid) override;
    mupdf::FzDocument* getFzDocument() override;

    void search(const QString& text) override;
    void clearSearch() override;
    void goToNextSearchHit() override;
    void goToPreviousSearchHit() override;

    void followLink(const char* uri) override;

    QString getFilePath() const override;
    int getPageCount() const override;
    int getCurrentPage() const override;
    void setCurrentPage(int newCurrentPage) override;
    float getZoom() const override;
    void setZoom(float newZoom) override;

    core::FilteredTOCModel* getTableOfContents() override;

private:
    ILibraryService* m_libraryService;
    domain::entities::Book* m_book = nullptr;
    std::unique_ptr<mupdf::FzDocument> m_fzDocument = nullptr;
    std::unique_ptr<core::utils::BookSearcher> m_bookSearcher = nullptr;
    float m_zoom = 1;

    std::unique_ptr<core::TOCModel> m_TOCModel;
    std::unique_ptr<core::FilteredTOCModel> m_filteredTOCModel;
};

}  // namespace application::services