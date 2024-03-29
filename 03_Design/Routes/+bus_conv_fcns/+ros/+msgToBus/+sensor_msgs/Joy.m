function slBusOut = Joy(msgIn, slBusOut, varargin)
%#codegen
%   Copyright 2021-2022 The MathWorks, Inc.
    currentlength = length(slBusOut.Header);
    for iter=1:currentlength
        slBusOut.Header(iter) = bus_conv_fcns.ros.msgToBus.std_msgs.Header(msgIn.Header(iter),slBusOut(1).Header(iter),varargin{:});
    end
    slBusOut.Header = bus_conv_fcns.ros.msgToBus.std_msgs.Header(msgIn.Header,slBusOut(1).Header,varargin{:});
    maxlength = length(slBusOut.Axes);
    recvdlength = length(msgIn.Axes);
    currentlength = min(maxlength, recvdlength);
    if (max(recvdlength) > maxlength) && ...
            isequal(varargin{1}{1},ros.slros.internal.bus.VarLenArrayTruncationAction.EmitWarning)
        diag = MSLDiagnostic([], ...
                             message('ros:slros:busconvert:TruncatedArray', ...
                                     'Axes', msgIn.MessageType, maxlength, max(recvdlength), maxlength, varargin{2}));
        reportAsWarning(diag);
    end
    slBusOut.Axes_SL_Info.ReceivedLength = uint32(recvdlength);
    slBusOut.Axes_SL_Info.CurrentLength = uint32(currentlength);
    slBusOut.Axes = single(msgIn.Axes(1:slBusOut.Axes_SL_Info.CurrentLength));
    if recvdlength < maxlength
    slBusOut.Axes(recvdlength+1:maxlength) = 0;
    end
    maxlength = length(slBusOut.Buttons);
    recvdlength = length(msgIn.Buttons);
    currentlength = min(maxlength, recvdlength);
    if (max(recvdlength) > maxlength) && ...
            isequal(varargin{1}{1},ros.slros.internal.bus.VarLenArrayTruncationAction.EmitWarning)
        diag = MSLDiagnostic([], ...
                             message('ros:slros:busconvert:TruncatedArray', ...
                                     'Buttons', msgIn.MessageType, maxlength, max(recvdlength), maxlength, varargin{2}));
        reportAsWarning(diag);
    end
    slBusOut.Buttons_SL_Info.ReceivedLength = uint32(recvdlength);
    slBusOut.Buttons_SL_Info.CurrentLength = uint32(currentlength);
    slBusOut.Buttons = int32(msgIn.Buttons(1:slBusOut.Buttons_SL_Info.CurrentLength));
    if recvdlength < maxlength
    slBusOut.Buttons(recvdlength+1:maxlength) = 0;
    end
end
