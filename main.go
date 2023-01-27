//go:build go1.19

package ImageGallery

import "embed"

//go:embed src/templates
var templateFS embed.FS

//go:embed src/www
var wwwFS embed.FS

var title = "ImageGallery"

func main() {

}
