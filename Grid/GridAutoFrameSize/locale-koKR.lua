local L = AceLibrary("AceLocale-2.2"):new("GridAutoFrameSize")

L:RegisterTranslations("koKR", function() return
{
	AUTO_SIZE = "공격대 창 자동 크기",
	AUTO_SIZE_DESC = "자동적으로 공격대 규모의 배치로 창을 조정합니다.",
	FORCE_PETS = "항상 소환수 배치 사용",
	FORCE_PETS_DESC = "기본적으로 소환수를 포함한 배치를 사용합니다. 40인 공격대는 사용되지 않습니다.",
	WITH_PETS = "당신의 소환수가 있다면, 소환수 배치 사용",
	WITH_PETS_DESC = "당신의 소환수가 있다면, 소환수를 포함한 배치를 사용합니다.",
	ZONE_SIZE = "미리 지정한 지역 크기 사용",
	ZONE_SIZE_DESC = "자동적으로 배치의 크기를 당신이 입장하는 지역에 맞춥니다. 예. 검은 사원 / 태양샘 25인 공격대",
}

end)