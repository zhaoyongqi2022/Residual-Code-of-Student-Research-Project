%% This function aims to convert kml-file into a array in MATLAB
% Author Yongqi Zhao
% Date July 22, 2021
%
% Input: filename of kml-file
%
% Oupt: Array: 
% Column 1: GPS Time (Second)
% COlumn 2: Latitude (Degree)
% Column 3: Longitude (Degree)
% Column 4: Height (Degree)
% Column 5: Northern Velocity (m/s)
% Column 6: Eastern Velocity (m/s)
% Column 7: Down Velocity (m/s)
% Column 8: Attitude Roll (Degree)
% Column 9: Attitude Pitch (Degree)
% Column 10: Attitude Yaw (Degree)
% Velocity has been transformated from ENU to NED, but attitude are still
% remained ENU

function kmlStruct = get_kml(kmlFile)

[FID msg] = fopen(kmlFile,'rt');

if FID<0
    error(msg)
end

txt = fread(FID,'uint8=>char')';
fclose(FID);

expr = '<Placemark.+?>.+?</Placemark>';

objectStrings = regexp(txt,expr,'match');

Nos = length(objectStrings);

for ii = 1:Nos
    % Find Object Name Field
    bucket = regexp(objectStrings{ii},'<name.*?>.+?</name>','match');
    if isempty(bucket)
        name = 'undefined';
    else
        % Clip off flags
        name = regexprep(bucket{1},'<name.*?>\s*','');
        name = regexprep(name,'\s*</name>','');
    end
    
    % Find Object Description Field
    bucket = regexp(objectStrings{ii},'<description.*?>.+?</description>','match');
    if isempty(bucket)
        desc = '';
    else
        % Clip off flags
        desc = regexprep(bucket{1},'<description.*?>\s*','');
        desc = regexprep(desc,'\s*</description>','');
    end
    
    % Find Coordinate Field
    bucket = regexp(objectStrings{ii},'<coordinates.*?>.+?</coordinates>','match');
    % Clip off flags
    coordStr = regexprep(bucket{1},'<coordinates.*?>(\s+)*','');
    coordStr = regexprep(coordStr,'(\s+)*</coordinates>','');
    % Split coordinate string by commas or white spaces, and convert string
    % to doubles
    coordMat = str2double(regexp(coordStr,'[,\s]+','split'));
    % Rearrange coordinates to form an x-by-3 matrix
    [m,n] = size(coordMat);
    coordMat = reshape(coordMat,3,m*n/3)';
    
    
    % Find velocity filed:(NED) and Attitude (roll,pitch,yaw)
    bucket = regexp(objectStrings{ii},'<TR ALIGN=RIGHT.*?>.+?</TD></TR>','match');      
    if length(bucket)==10
        velocity=bucket{7};
        attitude=bucket{9};
    elseif length(bucket)==11
        velocity=bucket{7};
        attitude=bucket{10};
    end
    % kick off flags
    velocity = regexprep(velocity,'[<TR ALIGN=RIGHT><TD ALIGN=LEFT>Vel(e,n,h):(ms)]','');
    velocity = str2double(regexp(velocity,'[/\s]+','split'));
    % Velocity in NED
    vel_n=velocity(3);
    vel_e=velocity(2);
    vel_d=-velocity(4);
    
    
    
    % attitude in structure
    
    % kick off flags
    attitude= regexprep(attitude,'[<TR ALIGN=RIGHT><TD ALIGN=LEFT>Att(r,p,h):(deg,approx)]','');
    attitude = str2double(regexp(attitude,'[/\s]+','split'));
    % attitude in [roll,pitch,yaw]
    att_r=attitude(2);
    att_p=attitude(3);
    att_y=attitude(4);

    % Create Output
    kmlStruct(ii,1)= str2double(name);    % GPS Time
    kmlStruct(ii,2) = coordMat(2);        % Latitude
    kmlStruct(ii,3) = coordMat(1);        % Longitude
    kmlStruct(ii,4)= coordMat(3);         % Height
    kmlStruct(ii,5)= vel_n;               % northern velocity
    kmlStruct(ii,6)= vel_e;               % eastern velocity
    kmlStruct(ii,7)= vel_d;               % down velocity
    kmlStruct(ii,8)= att_r;               % attitude roll
    kmlStruct(ii,9)= att_p;               % attitude pitch
    kmlStruct(ii,10)= att_y;              % attitude yaw
    
end