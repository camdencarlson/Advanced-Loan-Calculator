%% Loan Calculator and Budget Program
% 02.21.2023
clear
clc

totalMonthlyDebtPayment = 3975; % INPUT in $ dollars

%% Amortization Calculator
% Loan Information
%


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

for j = 1:length(loans) 
    principal = loans{j}.ogPrincipal;
    i = loans{j}.i /100/12;
    term = loans{j}.loanTerm;
    monthlyPayment = principal * (i*(1+i)^term)/((1+i)^term - 1);
    
    principalArray = [principal];
    interestArray = [0];
    principalPayment = [];
    count = 1;
    while principal > 0
        interestArray(count + 1,1) = principal * i;
        principalPayment(count + 1,1) = monthlyPayment - principal*i;
        principal = principal - (monthlyPayment - principal*i);
        principalArray(count + 1,1) = principal;
        count = count + 1;
    end
    monthPaymentArray = ones(length(principalArray),1) .* monthlyPayment;
    amortStruct = [monthPaymentArray,interestArray, principalPayment,principalArray];
    loans{j}.AmortSch = [amortStruct];

end

%% 
clc

for i = 1:length(loans)
    interestRates(i) = loans{i}.i;
end
[interestRatesSorted, sortIndex] = sort(interestRates,"descend") ;
interestRatesSorted = interestRatesSorted ./100./12;
loansByPayoff = loans(sortIndex);

names = [""];
for i = 1:length(loansByPayoff)
    names(i) = loansByPayoff{i}.name;
end

names = cellstr(names);

paymentSchedule = zeros(45,length(loansByPayoff) + 1);
paymentSchedule(:,1) = [1:45]';


for x = 1:length(loansByPayoff)
        amortSch2 = loansByPayoff{x}.AmortSch;
        minPayments(x) = amortSch2(1,1);
     
        paymentSchedule(1,x+1) = amortSch2(loansByPayoff{x}.currTerm,4);
end

Term = 1;
storedPayments = [];
for j = 1:length(loansByPayoff)
    
    if ~(paymentSchedule(Term,j+1) > 1)
        continue
    end
    principal = paymentSchedule(Term,j+1);
    index = ones(1,length(loansByPayoff));
    index(j) = 0;
    paymentMatrix = minPayments;
    minPaymentsForOtherLoans = sum(minPayments(boolean(index)));
    loanMaxPayoff = totalMonthlyDebtPayment - minPaymentsForOtherLoans;
    paymentMatrix(j) = loanMaxPayoff;
    while (principal > loanMaxPayoff - principal*interestRatesSorted(j)) && principal > 0
        principalPayment = paymentMatrix - paymentSchedule(Term,2:end) .* interestRatesSorted;
        paymentSchedule(Term + 1,2:end) =  paymentSchedule(Term,2:end) - principalPayment;
        principal = paymentSchedule(Term + 1,1 + j);
        storedPayments(Term,:) = paymentMatrix;
        Term = Term + 1;
    end
    if round(principal) > 0
        lastPayment = principal + principal*interestRatesSorted(j);
    else 
        lastPayment = 0;
    end
    
    
    if j < length(loansByPayoff) && principal > 0
        paymentMatrix(j) = lastPayment;
        if (paymentSchedule(Term,j+2)+paymentSchedule(Term,j+2)*interestRatesSorted(j+1))...
                < (loanMaxPayoff - lastPayment + paymentMatrix(j+1)) && j < length(loansByPayoff)-1
            paymentMatrix(j+1) = paymentSchedule(Term,j+2)+paymentSchedule(Term,j+2)*interestRatesSorted(j+1);
            paymentMatrix(j+2) = loanMaxPayoff - lastPayment - paymentMatrix(j+1) + paymentMatrix(j+2);

            if (paymentMatrix(j+2) > paymentSchedule(Term, j+3) + paymentSchedule(Term, j+3)...
                    *interestRatesSorted(j+2)) && j < length(loansByPayoff) -2
                paymentMatrix(j+2) = paymentSchedule(Term, j+3) + paymentSchedule(Term, j+3)*interestRatesSorted(j+2);
                paymentMatrix(j+3) = loanMaxPayoff - lastPayment - paymentMatrix(j+1) - paymentMatrix(j+2) + paymentMatrix(j+3);

                if (paymentMatrix(j+3) > paymentSchedule(Term, j+4) + paymentSchedule(Term, j+4)...
                    *interestRatesSorted(j+3)) && j < length(loansByPayoff) -3
                    paymentMatrix(j+3) = paymentSchedule(Term, j+4) + paymentSchedule(Term, j+4)*interestRatesSorted(j+3);
                    paymentMatrix(j+4) = loanMaxPayoff - lastPayment - paymentMatrix(j+1)...
                        - paymentMatrix(j+2) - paymentMatrix(j+3) + paymentMatrix(j+4);
                end
            end
            
            principalPayment = paymentMatrix - paymentSchedule(Term,2:end) .* interestRatesSorted;
            paymentSchedule(Term + 1,2:end) =  paymentSchedule(Term,2:end) - principalPayment;
            storedPayments(Term,:) = paymentMatrix;
            Term = Term + 1;
            minPayments(j) = 0;
            minPayments(j+1) = 0;
            
        else
            paymentMatrix(j+1) = paymentMatrix(j+1) + (loanMaxPayoff - lastPayment);
            principalPayment = paymentMatrix - paymentSchedule(Term,2:end) .* interestRatesSorted;
            
            paymentSchedule(Term + 1,2:end) =  paymentSchedule(Term,2:end) - principalPayment;
            paymentSchedule(Term + 1,1+j) = round(paymentSchedule(Term + 1,1+j));
            storedPayments(Term,:) = paymentMatrix;
            Term = Term + 1;
            minPayments(j) = 0;
        end
        
    end
    
end


for i = 1:length(storedPayments(:,1))
    totPaymentChecker(i) = sum(storedPayments(i,:));
end

totPaymentChecker;



%% make pretty table
header = [{'Period'}, names];
T = array2table(paymentSchedule,...
    'VariableNames',header)

