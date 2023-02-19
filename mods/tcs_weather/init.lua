require("config")

local syncTime = 0
local randomWeather = 0
local timeHour = Config.timeHour
local timeMinute = Config.timeMinute
local dateDay = Config.dateDay
local dateMonth = Config.dateMonth
local weatherSeason = 0
local weatherName = nil

registerForEvent("init", function()
    rndmWeather()
    syncWeather()
end)

registerForEvent("update", function(delta)
    syncTime = syncTime + delta
    randomWeather = randomWeather + delta

    if syncTime > Config.timeBeforeSync then
        syncTime = 0
        syncWeather()
    end

    if randomWeather > Config.timeBeforeRndmWeather then
        randomWeather = 0
        rndmWeather()
    end
end)

function syncWeather()
    local weatherDisplayName = nil
    timeMinute = timeMinute + Config.timePassedEverySync

    if timeMinute > 59 then
        timeMinute = 0
        timeHour = timeHour + 1
    end

    if timeHour > 23 then
        timeHour = 0
        dateDay = dateDay + 1
    end

    if dateDay > 30 then
        dateDay = 1
        dateMonth = dateMonth + 1
        if dateMonth > 12 then
            dateMonth = 1
        end
    end

    if dateMonth == 12 or dateMonth == 1 or dateMonth == 2 then
        -- hiver
        weatherSeason = 2
        weatherDisplayName = Config.displayWinterLog
    elseif dateMonth == 3 or dateMonth == 4 or dateMonth == 5 then
        -- printemps
        weatherSeason = 4
        weatherDisplayName = Config.displaySpringLog
    elseif dateMonth == 6 or dateDay == 7 or dateMonth == 8 then
        -- été  
        weatherSeason = 1
        weatherDisplayName = Config.displaySummerLog
    elseif dateMonth == 9 or dateMonth == 10 or dateMonth == 11 then
        -- automne
        weatherSeason = 3
        weatherDisplayName = Config.displayFallLog
    end

    world.hour = timeHour
    world.minute = timeMinute
    world.day = dateDay
    world.month = dateMonth
    world.season = weatherSeason
    world.weather = weatherName
    world:RpcSet()
    print("syncTime: " ..timeHour.."H"..timeMinute.." - "..dateDay.."."..dateMonth.." - "..weatherDisplayName.." - "..weatherName)
end

function rndmWeather()
    if dateMonth == 12 or dateMonth == 1 or dateMonth == 2 then
        -- hiver
        local weatherRndm = math.random(1, #Config.winterWeather)
        weatherName = Config.winterWeather[weatherRndm]
    elseif dateMonth == 3 or dateMonth == 4 or dateMonth == 5 then
        -- printemps
        local weatherRndm = math.random(1, #Config.springWeather)
        weatherName = Config.springWeather[weatherRndm]
    elseif dateMonth == 6 or dateDay == 7 or dateMonth == 8 then
        -- été
        local weatherRndm = math.random(1, #Config.summerWeather)
        weatherName = Config.summerWeather[weatherRndm]
    elseif dateMonth == 9 or dateMonth == 10 or dateMonth == 11 then
        -- automne
        local weatherRndm = math.random(1, #Config.fallWeather)
        weatherName = Config.fallWeather[weatherRndm]
    end

    world.weather = weatherName
    world:RpcSet()
    print("Changing weather for "..weatherName)
end