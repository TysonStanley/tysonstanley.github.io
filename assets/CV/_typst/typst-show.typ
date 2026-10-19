// Quarto template partial: typst-show.typ
// Applies the CV layout defined in typst-template.typ to the document body.
#show: cv.with(
$if(title)$
  title: "$title$",
$endif$
)
