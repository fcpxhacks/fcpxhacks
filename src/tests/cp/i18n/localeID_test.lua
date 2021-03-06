-- test cases for `cp.is`
local test          = require("cp.test")
local localeID    = require("cp.i18n.localeID")

local pack              = table.pack
local parse, forCode    = localeID.parse, localeID.forCode

return test.suite("cp.i18n.languageID"):with {
    test("parse", function()
        -- good codes
        ok(eq(pack(parse("en")), pack("en", nil, nil)))
        ok(eq(pack(parse("English")), pack("English", nil, nil)))
        ok(eq(pack(parse("en_AU")), pack("en", "AU", nil)))
        ok(eq(pack(parse("en-Latn")), pack("en", nil, "Latn")))
        ok(eq(pack(parse("en-Latn_AU")), pack("en", "AU", "Latn")))

        -- bad codes
        local nada = pack(nil, nil, nil)
        ok(eq(pack(parse("en-AU")), nada))
        ok(eq(pack(parse("English_AU")), nada))
        ok(eq(pack(parse("en_AU-Latn")), nada))
        ok(eq(pack(parse("en-AUX")), nada))
        ok(eq(pack(parse("en-Latin")), nada))
        ok(eq(pack(parse("EN-AU")), nada))
    end),

    test("forCode", function()
        local id

        id = forCode("en")
        ok(eq(id.code, "en"))
        ok(eq(id.language.alpha2, "en"))
        ok(eq(id.region, nil))
        ok(eq(id.script, nil))

        id = forCode("English")
        ok(eq(id.code, "en"))
        ok(eq(id.language.alpha2, "en"))
        ok(eq(id.region, nil))
        ok(eq(id.script, nil))

        id = forCode("en_AU")
        ok(eq(id.code, "en_AU"))
        ok(eq(id.language.alpha2, "en"))
        ok(eq(id.region.alpha2, "AU"))
        ok(eq(id.script, nil))

        id = forCode("en-Latn")
        ok(eq(id.code, "en-Latn"))
        ok(eq(id.language.alpha2, "en"))
        ok(eq(id.region, nil))
        ok(eq(id.script.alpha4, "Latn"))

        id = forCode("English_AU")
        ok(eq(id, nil))

        id = forCode("xx")
        ok(eq(id, nil))

        id = forCode("en-XX")
        ok(eq(id, nil))

        id = forCode("en-Xxxx")
        ok(eq(id, nil))

        id = forCode("Bad Code")
        ok(eq(id, nil))
    end),

    test("matches", function()
        local l = localeID.forCode
        local en, en_AU, en_Latn, en_Latn_AU, en_NZ, de = l("en"), l("en_AU"), l("en-Latn"), l("en-Latn_AU"), l("en_NZ"), l("de")

        ok(eq(en:matches(de), 0))               -- no match - different language

        ok(eq(en:matches(en), 3))               -- language, script, and region match exactly
        ok(eq(en:matches(en_AU), 2.5))          -- language and script match, region half-match with one side "open".
        ok(eq(en:matches(en_Latn), 2.5))        -- language and region match, script half-match with one side "open".
        ok(eq(en:matches(en_Latn_AU), 2))       -- language matches, two half-matches for script and region.

        ok(eq(en_AU:matches(en_AU), 3))         -- exact match
        ok(eq(en_AU:matches(en), 2.5))          -- language and script match, region half-match with a `nil` on one side.
        ok(eq(en_AU:matches(en_NZ), 2))         -- language and script match, but no match between specific regions.
        ok(eq(en_AU:matches(en_Latn_AU), 2.5))  -- language and region match exactly, and the optional `script` value is different.
    end),

    test("for name not code", function()
        local english = localeID("English")
        ok(eq(english.code, "en"))
        ok(eq(english.name, "English"))
        ok(eq(english.aliases, {"en", "English"}))
    end),
}