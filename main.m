%% Loan Calculator and Budget Program
% Last Edit: 02.21.2023
clc
clear

% INPUT YOUR PAYMENT TOWARD DEBT HERE
totalMonthlyDebtPayment = 4500; % INPUT in $ dollars
lumpSumBool = true; % do you want to use a lump sum?
lumpSum = 23000; %% the lump sum amount
lumpSumIndex = 1; % the month at which you make the lump sum payment
% 


% ************************************************ %



% Loan Setup & Information
% Create struct with all necesary information:
% - struct.i = Interest Rate (in percent)
% - struct.ogPrincipal = Original Principal
% - struct.currPrincipal = Current principal (ogPrincipal by default)
% - struct.loanTerm = loan term in # of months
% - struct.name = name of the loan (whatever you want)
% - struct.currTerm = the current term of the loan you are on (1 by defalt)
% - struct.AmortSch = a double array for the amortization data to be entered

amortNames = ["Monthly Payment", "Interest Paid", "Principal Paid","Remaining"];

private.i = 4.74;
private.ogPrincipal = 76569.38;
private.currPrincipal = 68472.91;
private.loanTerm = 250; % in months
private.name = 'Private';
private.currTerm = 43+5;
private.AmortSch = table(amortNames);

auto.i = 8.33;
auto.ogPrincipal = 17401.09;
auto.currPrincipal = 16169.93;
auto.loanTerm = 66;
auto.name = 'Auto';
auto.currTerm = 8+5;
auto.AmortSch = table(amortNames);

federalOne.i = 3.76;
federalOne.ogPrincipal = 2750;
federalOne.loanTerm = 118;
federalOne.name = 'Federal 1';
federalOne.currTerm = 1;
federalOne.AmortSch = table(amortNames);

federalTwo.i = 4.45;
federalTwo.ogPrincipal = 4500; 
federalTwo.loanTerm = 118;
federalTwo.name = 'Federal 2';
federalTwo.currTerm = 1;
federalTwo.AmortSch = table(amortNames);

federalThree.i = 4.45;
federalThree.ogPrincipal = 2000;
federalThree.loanTerm = 118;
federalThree.name = 'Federal 3';
federalThree.currTerm = 1;
federalThree.AmortSch = table(amortNames);

federalFour.i = 5.05; 
federalFour.ogPrincipal = 5500;
federalFour.loanTerm = 118;
federalFour.name = 'Federal 4';
federalFour.currTerm = 1;
federalFour.AmortSch = table(amortNames);

federalFive.i = 5.05;
federalFive.ogPrincipal = 2000;
federalFive.loanTerm = 118;
federalFive.name = 'Federal 5';
federalFive.currTerm = 1;
federalFive.AmortSch = table(amortNames);

federalSix.i = 4.53;
federalSix.ogPrincipal = 2750;
federalSix.loanTerm = 118;
federalSix.name = 'Federal 6';
federalSix.currTerm = 1;
federalSix.AmortSch = table(amortNames);

federalSeven.i = 4.53;
federalSeven.ogPrincipal = 1000;
federalSeven.loanTerm = 118;
federalSeven.name = 'Federal 7';
federalSeven.currTerm = 1;
federalSeven.AmortSch = table(amortNames);


loans = {private, auto, federalOne, federalTwo...
    federalThree, federalFour, federalFive, federalSix, federalSeven};



% Calculator setup
%amortize
loans = Amortizer(loans);
[T, storedPayments] = PaymentCalculator(loans, totalMonthlyDebtPayment, lumpSum, lumpSumBool, lumpSumIndex);
