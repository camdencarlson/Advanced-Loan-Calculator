%% Computes amortization table for loan
% Last Edit: 02.21.2023
% requires a struct input composed of:
% - struct.i = Interest Rate (in percent)
% - struct.ogPrincipal = Original Principal
% - struct.currPrincipal = Current principal (ogPrincipal by default)
% - struct.loanTerm = loan term in # of months
% - struct.name = name of the loan (whatever you want)
% - struct.currTerm = the current term of the loan you are on (1 by defalt)
% - struct.AmortSch = a double array for the amortization data to be entered
function [loans] = Amortizer(loans)
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
    
end