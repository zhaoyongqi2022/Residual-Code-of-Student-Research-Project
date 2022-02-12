%% This function aims to convert [year,month,day,hour,minute,second] to Modified Julian Day
%
% Input: [year,month,day,hour,minute,second]
%
% Output: Modified Julian Day

function mjd=cal2mjd(cal)
% cal2mjd	������������ʱ����ת�����������ա�
%  mjd=cal2mjd(cal)  ���ؼ�������
%  cal��1x6����6�зֱ�Ϊ������ʱ���롣����calʱ����ʡ��ĩβ��0

jd = cal2jd(cal);
mjd = jd - 2400000.5;
