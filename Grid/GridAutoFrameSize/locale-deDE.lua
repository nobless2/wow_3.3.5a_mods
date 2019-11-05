local L = AceLibrary("AceLocale-2.2"):new("GridAutoFrameSize")

L:RegisterTranslations("deDE", function() return
{
	AUTO_SIZE = "Automatische Schlachtzugsfenstergröße", -- Needs review
	AUTO_SIZE_DESC = "Passt das Fenster automatisch an die Schlachtzugsgröße an",
	FORCE_PETS = "Immer Anordnung mit Begelitern benutzen",
	FORCE_PETS_DESC = "Standardmäßig Anordnung mit Begleitern benutzen. Funktioniert nicht in 40-Mann-Schlachtzügen.",
	WITH_PETS = "Anordnungen mit Begleitern benutzen, wenn Dein Begleiter aktiv ist.",
	WITH_PETS_DESC = "Anordnungen mit Begleitern benutzen, wenn Dein Begleiter aktiv ist.",
	ZONE_SIZE = "Zonenabhängige Fenstergröße benutzen",
	ZONE_SIZE_DESC = "Passt die Fenstergröße automatisch der betretenen Zone an und sperrt die Größenanpassung bei Gruppenveränderungen.",
}

end)