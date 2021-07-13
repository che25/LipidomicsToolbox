## heatmap.2 does not allow specifying RowSideColors = NULL 

my_heatmap.2 = function(x, cc=NULL, rc=NULL, ...) {
  
  if(is.null(cc)) {
    if(is.null(rc)) {
      heatmap.2(x, ...)
    } else {
      heatmap.2(x, RowSideColors = rc, ...)
    }
  } else {
    if(is.null(rc)) {
      heatmap.2(x, ColSideColors = cc, ...)
    } else {
      heatmap.2(x, RowSideColors = rc, ColSideColors = cc, ...)
    }
  }

  
}