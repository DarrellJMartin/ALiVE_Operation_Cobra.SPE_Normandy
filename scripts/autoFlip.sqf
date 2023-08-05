MGI_fnc_unFlip = compileFinal "
  params [['_veh',objNull,[objNull]]];
  _veh allowCrewInImmobile[isAllowedCrewInImmobile _veh,FALSE];
  _veh addEventHandler ['GetOut', {
    params ['_veh'];
    if ((vectorUp _veh) vectorCos (surfaceNormal getPos _veh) <0.5) then {
      _veh allowDamage false;
      _veh setVectorUp [0,0,1];
      _veh setPosATL [(getPosATL _veh) select 0, (getPosATL _veh) select 1, 0];
      _veh allowDamage true;
    };
  }];
";

{_x call MGI_fnc_unFlip} forEach (vehicles select {_x isKindOf "landVehicle"});

addMissionEventHandler ["entityCreated", {
  params ["_obj"];
  if (_obj isKindOf "landVehicle") then {
    _obj call MGI_fnc_unFlip
  };
}];