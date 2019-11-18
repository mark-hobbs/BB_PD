
temp = CONSTRAINTFLAG;
temp(temp == 0) = 2;
temp(temp == 1) = 0;
temp(temp == 2) = 1;
CONSTRAINTFLAG = temp;
clear temp;