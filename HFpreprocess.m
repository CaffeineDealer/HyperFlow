classdef HFpreprocess
    properties
        fname
        nch
        Fs
        win
        offset
        sdUserMin
        sdUserMax
    end
    properties
        datapath0
        datapath1
    end
    methods
        function obj = HFpreprocess(params)
            obj.fname = params.fname;
            obj.nch = params.nch;
            obj.Fs = params.Fs;
            obj.win = params.win;
            obj.offset = params.offset;
            obj.sdUserMin = params.sdUserMin;
            obj.sdUserMax = params.sdUserMax;
        end
        function obj = configpath(obj,DATAPATH)
            obj.datapath0 = DATAPATH{1};
            obj.datapath1 = DATAPATH{2};
        end
        function plx = readPLX(obj)
            [~, plx.evts3, ~] = plx_event_ts(sprintf('%s%s-01.plx',obj.datapath0,obj.fname),3); % Trial start
            [~, plx.evts4, ~] = plx_event_ts(sprintf('%s%s-01.plx',obj.datapath0,obj.fname),4); % Fix on
            [~, plx.evts5, ~] = plx_event_ts(sprintf('%s%s-01.plx',obj.datapath0,obj.fname),5); % Fixating
            [~, plx.evts6, ~] = plx_event_ts(sprintf('%s%s-01.plx',obj.datapath0,obj.fname),6); % Stim on
            [~, plx.evts7, ~] = plx_event_ts(sprintf('%s%s-01.plx',obj.datapath0,obj.fname),7); % Stim stop
            [~, plx.evts8, ~] = plx_event_ts(sprintf('%s%s-01.plx',obj.datapath0,obj.fname),8); % Data Collection start
            [~, plx.evts9, ~] = plx_event_ts(sprintf('%s%s-01.plx',obj.datapath0,obj.fname),9); % Trial end
            [~, ~, plx.ts, ~, ~] = plx_ad_v(sprintf('%s%s-01.plx',obj.datapath0,obj.fname),1);
        end
        function mlogic = readMonkey(obj)
            mlogic = load([obj.datapath1,sprintf('%s_TrialStructure.mat',obj.fname)]);
            mlogic.stim.sizeDeg = mlogic.taskTrials.trialTaskValues.sizeDeg;
            mlogic.stim.sizeDegCond = mlogic.taskTrials.trialTaskValues.sizeDegCond;
            mlogic.stim.contrast = mlogic.taskTrials.trialTaskValues.contrast;
            mlogic.stim.contrastCond = mlogic.taskTrials.trialTaskValues.contrastCond;
        end
        function StimInfo = getFrameRate(obj)
            plx = readPLX(obj);
            ml = readMonkey(obj);
            StimInfo.StimOn = (plx.evts6 - plx.ts) * obj.Fs; % Stimulus on
            StimInfo.StimOff = (plx.evts7 - plx.ts) * obj.Fs; % Stimulus off
            StimInfo.fixOn = (plx.evts4 - plx.ts) * obj.Fs; % Fixation dot drawn
            StimInfo.StimFrameTimeML = (cell2mat({ml.taskTrials.frame.time})' - ml.taskTrials.fixationOnState) * obj.Fs;
            StimInfo.FrameRate = size(StimInfo.StimFrameTimeML,1)/(ml.taskTrials.frame(end).time - ml.taskTrials.frame(1).time); % Screen Refresh Rate
        end
    end
end