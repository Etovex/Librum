/**
  Handle the wheel usage, scroll or zoom depending on pressed modifiers
  */
function handleWheel(wheel)
{
    let factorX = wheel.angleDelta.x > 0 ? 1.13 : 0.88;
    let factorY = wheel.angleDelta.y > 0 ? 1.13 : 0.88;
    
    if (wheel.modifiers & Qt.ControlModifier)
    {
        zoom(BookController.zoom * factorY);
    }
    // angleDelta.x is the "horizontal scroll" mode some mouses support by
    // e.g. pushing the scroll button to the left/right.
    else if(wheel.angleDelta.x !== 0)
    {
        if(factorX > 1)
            flick(pageView.scrollSpeed / 3, 0);
        else
            flick(-pageView.scrollSpeed / 3, 0);
    }
    else
    {
        if(factorY > 1)
            flick(0, pageView.scrollSpeed);
        else
            flick(0, -pageView.scrollSpeed);
    }
}

// Calculate the current page and update the document.
function updateCurrentPageCounter()
{
    // A new page starts if it is over the middle of the screen (vertically).
    let pageHeight = pageView.currentItem.height + pageView.pageSpacing;
    let currentPos = pageView.contentY - pageView.originY + pageView.height/2;
    let pageNumber = Math.floor(currentPos / pageHeight);
    
    if(pageNumber !== BookController.currentPage)
        BookController.currentPage = pageNumber;
}


/**
  Changes the current move direction of the listview, without actually
  moving visibly. This is neccessary since the listview only chaches
  delegates in the direction of the current move direction.
  If we e.g. scroll downwards and then go to the previousPage
  by setting the contentY, the previous pages are not cached
  which might lead to visible loading while moving through the
  book with the arrow keys.
  */
function setMoveDirection(direction)
{
    if(direction === "up")
    {
        flick(0, -1000);
        pageView.cancelFlick();
    }
    else if(direction === "down")
    {
        flick(0, 1000);
        pageView.cancelFlick();
    }
}


function zoom(newZoomFactor)
{
    // Clamp to max / min zoom factors
    newZoomFactor = Math.max(0.15, Math.min(newZoomFactor, 5));
    if (newZoomFactor === BookController.zoom)
        return;
    
    let defaultPageHeight = Math.round(pageView.currentItem.height / BookController.zoom)
    let newPageHeight = Math.round(defaultPageHeight * newZoomFactor) + pageView.getPageSpacing(newZoomFactor);
    let currentPageHeight = pageView.currentItem.height + pageView.getPageSpacing(BookController.zoom);
    let currentPageNumber = BookController.currentPage;
    let currentPos = pageView.contentY - pageView.originY;
    
    let pageOffset = currentPos - (currentPageHeight * currentPageNumber);
    
    BookController.zoom = newZoomFactor;
    pageView.forceLayout();
    pageView.contentY = newPageHeight * currentPageNumber + pageOffset + pageView.originY;
}


function flick(x, y)
{
    pageView.flick(x, y);
}


function setPage(newPageNumber)
{
    if(newPageNumber < 0 || newPageNumber > BookController.pageCount)
        return;
    
    pageView.currentIndex = newPageNumber;
    pageView.positionViewAtIndex(newPageNumber, ListView.Beginning);
    BookController.currentPage = newPageNumber;
    
    if(newPageNumber > BookController.currentPage)
        setMoveDirection("up");
    else if(newPageNumber < BookController.currentPage)
        setMoveDirection("down");
}