#include "page.hpp"
#include "mupdf/classes.h"
#include "mupdf/classes2.h"

namespace application::core
{

application::core::Page::Page(const Document* document, int pageNumber) :
    m_document(document->internal())
{
    m_page = m_document->fz_load_page(pageNumber);
    auto boundPage = m_page.fz_bound_page();

    m_displayList = mupdf::FzDisplayList(boundPage);
    auto listDevice = m_displayList.fz_new_list_device();
    mupdf::FzCookie defaultCookie;
    m_page.fz_run_page(listDevice, mupdf::FzMatrix(), defaultCookie);
    listDevice.fz_close_device();
}

QImage Page::renderPage(bool invertColor)
{
    auto pixmap = getEmptyPixmap();
    auto drawDevice = mupdf::fz_new_draw_device(mupdf::FzMatrix(), pixmap);

    mupdf::FzCookie cookie;
    mupdf::FzRect rect = mupdf::FzRect::Fixed_INFINITE;
    m_displayList.fz_run_display_list(drawDevice, m_matrix, rect, cookie);
    drawDevice.fz_close_device();

    if(invertColor)
        pixmap.fz_invert_pixmap();

    return imageFromPixmap(pixmap);
}

mupdf::FzPixmap Page::getEmptyPixmap() const
{
    auto bbox = m_page.fz_bound_page_box(FZ_CROP_BOX);
    bbox = bbox.fz_transform_rect(m_matrix);

    mupdf::FzPixmap pixmap(mupdf::FzColorspace::Fixed_RGB, bbox,
                           mupdf::FzSeparations(), 0);
    pixmap.fz_clear_pixmap();

    return pixmap;
}

void imageCleanupHandler(void* data)
{
    unsigned char* samples = static_cast<unsigned char*>(data);
    delete[] samples;
}

QImage Page::imageFromPixmap(mupdf::FzPixmap pixmap)
{
    int width = pixmap.w();
    int height = pixmap.h();
    int stride = pixmap.stride();
    auto samples = pixmap.samples();

    // Copy samples
    std::size_t length = stride * height;
    unsigned char* destination = new unsigned char[length + 1];
    std::copy(samples, samples + length + 1, destination);

    QImage image(destination, width, height, stride, QImage::Format_RGB888,
                 imageCleanupHandler, destination);
    return image;
}

int Page::getWidth() const
{
    auto bbox = m_page.fz_bound_page_box(FZ_CROP_BOX);

    return (bbox.x1 - bbox.x0) * m_matrix.a;
}

int Page::getHeight() const
{
    auto bbox = m_page.fz_bound_page_box(FZ_CROP_BOX);

    return (bbox.y1 - bbox.y0) * m_matrix.d;
}

void Page::setZoom(float newZoom)
{
    m_matrix.a = newZoom;
    m_matrix.d = newZoom;
}

}  // namespace application::core