function [] = runningGUI()
    close all;
    global run;
    run.fig = figure();
    run.editBox = uicontrol('style','edit','units','normalized','position',[.20 .75 .40 .10],'callback',{@paceNum});
    %creates edit box for user to input desired pace
    run.bg = uibuttongroup('units','normalized','position',[.2 .4 .4 .2],'SelectionChangedFcn',{@bgSelection});
    r1 = uicontrol(run.bg,'style','radiobutton','string','Minutes Per Mile','units','normalized','position',[.1 .6 .9 .2]);
    r2 = uicontrol(run.bg, 'style','radiobutton','string','Minutes Per Kilometer','units','normalized','Position',[.1 .3 .9 .2]);
    %creates button group to select units
    run.popUp = uicontrol('style','popupmenu','units','normalized','position',[.2 .15 .4 .1],'string',{'1 mile','5 kilometer','15 kilometer','half marathon','marathon'},'callback',{@distanceSelection});
    %creates dropdown menu to select distance
    run.boxText = uicontrol('style','text','units','normalized','Position',[.2 .85 .4 .05],'string','Desired Pace: ');
    run.unitText = uicontrol('Style','text','units','normalized','Position',[.2 .60 .4 .05],'String','Desired Units: ');
    run.distText = uicontrol('Style','text','units','normalized','Position',[.2 .25 .4 .05],'String','Desired Distance: ');
    %text for clarity of each element's use
end

function [] = paceNum(source,event)
    global run;
    run.pace = get(run.editBox,'String');
    if regexp(run.pace,'^[0-5]?[0-9]:[0-5][0-9]$')
        run.paceTime = split(run.pace,':');
        run.min = str2double(run.paceTime{1});
        run.sec = str2double(run.paceTime{2});
        run.allSec = (run.min * 60) + run.sec;
        %checks that pace input is in m:ss format, splits input into
        %minutes and seconds and converts into seconds only
    else
        msgbox('Error! Please input a time in format m:ss','Can Not Compute','error','modal');
        %if input isn't in m:ss format, error appears
    end
end

function [] = bgSelection(source,event)
    global run;
    conversion = 0;
    run.conversion = 1;
    if strcmp(event.NewValue.String,'Minutes Per Mile')
        conversion = 1;
    elseif event.NewValue.String == 'Minutes Per Kilometer'
            conversion = 1.60934;
            %creates conversion factors depending on units selected
    end
    run.conversion = conversion;
    %saves local variables to global, could not use global for if statements
end

function [] = distanceSelection(source,event)
global run;
val = run.popUp.Value;
str = run.popUp.String;
selectedDist = str{val};
%gets user selection
    if strcmp(selectedDist,'1 mile')
        run.allSec = run.allSec * run.conversion;
    elseif strcmp(selectedDist,'5 kilometer')
        run.allSec = run.allSec * 3.10686 * run.conversion;
    elseif strcmp(selectedDist,'15 kilometer')
        run.allSec = run.allSec * 9.32057 * run.conversion;
    elseif strcmp(selectedDist,'half marathon')
        run.allSec = run.allSec * 13.1 * run.conversion;
    elseif strcmp(selectedDist,'marathon')
        run.allSec = run.allSec * 26.2 * run.conversion;
    end
    %multiplies pace input by number of miles and conversion factor
    run.finalSec = (run.allSec/60);
    finalSec = run.finalSec;
    run.secOnly = run.finalSec - floor(run.finalSec);
    secOnly = run.secOnly;
    %converting output back into minutes and seconds
    run.final = string(floor(run.finalSec)) + ':' + string(round(run.secOnly * 60));
    %formatting minutes and seconds into m:ss format again
    message = sprintf('Your %s run will take %s', string(selectedDist), string(run.final));
    msgbox(message,'Result','modal')
    %message box appears displaying final time
end