/* 
* Filename:
* initServer.sqf
*
* Description:
* Executed only on server when mission is started.
* 
* Creation date: 05/04/2021
* 
* */
// ====================================================================================
if (isDedicated) then  { 
	disableRemoteSensors true; 
};

[] spawn {
     while {true} do {
          {
               if (!isNull (getAssignedCuratorUnit _x)) then {
                    _x addCuratorEditableObjects [allUnits + vehicles,true];
               };
          } count allCurators;
          sleep 10;
     };
};

call (compile preprocessFileLineNumbers "mapmarker\scripts\fn_init.sqf");
call MM_fnc_startMapMarkerServer;

if !isMultiplayer then {
	addMissionEventHandler ["Loaded", {
		call MM_fnc_stopMapMarkerClient;

		[] spawn {
			waitUntil {!MM_var_clientRunning};
			call MM_fnc_startMapMarkerClient;
		};
	}];
};

// Returns array of dates for given year when moon is at its fullest
fnc_fullMoonDates =
{
	private _year = param [0, 2035];
	private ["_date", "_phase", "_fullMoonDate"];
	private _fullMoonPhase = 1;
	private _waxing = false;
	private _fullMoonDates = [];
	for "_i" from dateToNumber [_year, 1, 1, 0, 0] to dateToNumber [_year, 12, 31, 23, 59] step 1 / 365 do
	{
		_date = numberToDate [_year, _i];
		_phase = moonPhase _date;

		call
		{
			if (_phase > _fullMoonPhase) exitWith
			{
				_waxing = true;
				_fullMoonDate = _date;
			};

			if (_waxing) exitWith
			{
				_waxing = false;
				_fullMoonDates pushBack _fullMoonDate;
			};
		};

		_fullMoonPhase = _phase;
	};

	_fullMoonDates;
}; 	

//set random full moon date in year 1944
setDate selectRandom (1944 call fnc_fullMoonDates); 
skipTime 8;
0 setOvercast 0.1;  
0 setRain 0;  
0 setfog 0.01; 
forceWeatherChange;

["Initialize", [true]] call BIS_fnc_dynamicGroups;	

SPE_IFS_CASAvailability_Side = [east, west, independent];
publicVariable "SPE_IFS_CASAvailability_Side";
