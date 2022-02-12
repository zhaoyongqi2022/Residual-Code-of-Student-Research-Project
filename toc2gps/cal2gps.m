function gpst=cal2gps(cal)
% cal2gps	������GPSʱ��ת����GPS�ܺ����ڵ��롣
%  gpst==cal2gps(cal)  ���ص�gpst��1x2����2�зֱ�ΪGPS�ܺ�������
%  cal��1x6����6�зֱ�Ϊ������ʱ���롣����calʱ����ʡ��ĩβ��0

if length(cal) < 6
	cal(6)=0;
end
mjd=cal2mjd(cal);
% GPS��MJD44244��ʼ
elapse=mjd-44244;
week=floor(elapse/7);
elapse=elapse-week*7;	% ��������
gpst=[week round(elapse*86400)];
