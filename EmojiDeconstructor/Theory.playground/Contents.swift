/*:
 ## Theory Behind `EmojiDeconstructor`
 -- Jennifer Starratt
 
 
 Originally was going to be a constructor, but I didn't like it nearly as much.
 
 #### Build
 */
// Simple:
"🙆" + "🏻"

// Complicated:
let binding = "\u{200D}"

"👨" + binding + "👩" + binding + "👧"
/*:
 #### Deconstruct
 */
let lightSkinToneOk = "🙆" + "🏻"
let lightSkinToneOkUnicodes = lightSkinToneOk.unicodeScalars
    .map { $0.escaped(asASCII: false) }
lightSkinToneOkUnicodes.forEach { print($0) }
