# CSS Image Sprites
#css #images #sprites #pseudo-class

An image sprite is a collection of images put into a single image.
A web page with many images can take a long time to load and generate
multiple server requests.
Using image sprites will reduce the number of requests and save bandwidth.

Instead of using 3 separate images we can use a single one that contains 3:
```css
#home {
  width: 43px;
  height: 44px;
  background: url(img_nav_sprites.gif) 0 0;
}
#prev {
  width: 43px;
  height: 44px;
  background: url(img_nav_sprites.gif) -47px 0;
}
#next {
  width: 43px;
  height: 44px;
  background: url(img_nav_sprites.gif) -91px 0;
}
```
```html
<img id="home" src="img_trans.gif" width="1" height="1">
<img id="prev" src="img_trans.gif" width="1" height="1">
<img id="next" src="img_trans.gif" width="1" height="1">
```
This could be used to create a navigation list.

If we had a 2x3 sprite sheet, where the first row contains the regular
sprites and the second row contains darker versions, we could use
the `:hover` pseudo-class to replace lighter sprites with their
darker counterparts.
```css
#home a:hover {
  background: url('img_nav_sprites_hover.gif') 0 -45px;
}
#prev a:hover {
  background: url('img_nav_sprites_hover.gif') -47px -45px;
}
#next a:hover {
  background: url('img_nav_sprites_hover.gif') -91px -45px;
}
```
