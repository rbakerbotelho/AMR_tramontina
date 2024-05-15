classdef EnumLocalizationStatus < Simulink.IntEnumType

    enumeration
    Ok(10)
    Warning(20)
    NotLocalized(30)
    SystemError(40)
    Undefined(100)
  end

end
