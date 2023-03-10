%% The Advanced Loan Calculator
% Uses avalanche method (identifies loan with highest interest rate
% and creates a payment schedule
%
% Outputs:
% T - table with principal information
% bla bla stuff ill put later
%
function [T, storedPayments] = PaymentCalculator(loans, totalMonthlyDebtPayment, lumpSum, lumpSumBool, lumpSumIndex)
    for i = 1:length(loans)
        interestRates(i) = loans{i}.i; 
    end
    [interestRatesSorted, sortIndex] = sort(interestRates,"descend"); % interest rates now sorted from largest to smallest
    interestRatesSorted = interestRatesSorted ./100./12;
    loansByPayoff = loans(sortIndex); % loans put in order of which will be paid off first
    
    % Names for putting in the table at the end
    names = [""];
    for i = 1:length(loansByPayoff)
        names(i) = loansByPayoff{i}.name;
    end
    names = cellstr(names);
    %

    % arbitrary size of loan payments
    noLoanPayments = 100;
    paymentSchedule = zeros(noLoanPayments,length(loansByPayoff) + 1);
    paymentSchedule(:,1) = [1:noLoanPayments]';
    
    % get minimum payments set in place
    for x = 1:length(loansByPayoff)
            amortSch2 = loansByPayoff{x}.AmortSch;
            minPayments(x) = amortSch2(1,1);
            paymentSchedule(1,x+1) = amortSch2(loansByPayoff{x}.currTerm,4);
    end
    

    % initialize loop parameters
    Term = 1; % term of starting payments
    storedPayments = [];
    for j = 1:length(loansByPayoff) % LOOP OVER ALL LOANS
        if ~(paymentSchedule(Term,j+1) > 1)
            continue
        end

        principal = paymentSchedule(Term,j+1);
        index = ones(1,length(loansByPayoff));
        index(j) = 0;
        paymentMatrix = minPayments;
        minPaymentsForOtherLoans = sum(minPayments(boolean(index)));

        if lumpSumBool
            if lumpSumIndex == j
                loanMaxPayoff = lumpSum + totalMonthlyDebtPayment - minPaymentsForOtherLoans;
            else
                loanMaxPayoff = totalMonthlyDebtPayment - minPaymentsForOtherLoans;
            end
        else 
            loanMaxPayoff = totalMonthlyDebtPayment - minPaymentsForOtherLoans;
        end

        paymentMatrix(j) = loanMaxPayoff;

        % MAKE PAYMENTS ON THIS LOAN UNTIL THE LOAN IS FINISHED
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
        
        
        % NOW THE REMAINING DOLLARS OF THE LOAN NEED TO BE PAID AND SPLIT
        if j < length(loansByPayoff) && principal > 0
            paymentMatrix(j) = lastPayment;
            if (paymentSchedule(Term,j+2)+paymentSchedule(Term,j+2)*interestRatesSorted(j+1))...
                    < (loanMaxPayoff - lastPayment + paymentMatrix(j+1)) && j < length(loansByPayoff)-1
                paymentMatrix(j+1) = paymentSchedule(Term,j+2)+paymentSchedule(Term,j+2)*interestRatesSorted(j+1);
                paymentMatrix(j+2) = loanMaxPayoff - lastPayment - paymentMatrix(j+1) + paymentMatrix(j+2) + minPayments(j+1);
                
                if (paymentMatrix(j+2) > paymentSchedule(Term, j+3) + paymentSchedule(Term, j+3)...
                        *interestRatesSorted(j+2)) && j < length(loansByPayoff) -2
                    paymentMatrix(j+2) = paymentSchedule(Term, j+3) + paymentSchedule(Term, j+3)*interestRatesSorted(j+2);
                    paymentMatrix(j+3) = loanMaxPayoff - lastPayment - paymentMatrix(j+1) - paymentMatrix(j+2) + paymentMatrix(j+3) + minPayments(j+1) + minPayments(j+2);
                    
                    if (paymentMatrix(j+3) > paymentSchedule(Term, j+4) + paymentSchedule(Term, j+4)...
                        *interestRatesSorted(j+3)) && j < length(loansByPayoff) -3
                        paymentMatrix(j+3) = paymentSchedule(Term, j+4) + paymentSchedule(Term, j+4)*interestRatesSorted(j+3);
                        paymentMatrix(j+4) = loanMaxPayoff - lastPayment - paymentMatrix(j+1)...
                            - paymentMatrix(j+2) - paymentMatrix(j+3) + paymentMatrix(j+4) + minPayments(j+1) + minPayments(j+2) + minPayments(j+3);
                        minPayments(j) = 0;
                        minPayments(j+1) = 0;
                        minPayments(j+2) = 0;
                        minPayments(j+3) = 0;
                    end
                    minPayments(j) = 0;
                    minPayments(j+1) = 0;
                    minPayments(j+2) = 0;
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
        % END OF PAYING EXTRA LOANS AND SPLITTING
    end
    % REPEAT FOR EACH LOAN


    % A checker to make sure the correct dollar amounts are being given
    % each month
    totPaymentChecker = [];
    for i = 1:length(storedPayments(:,1))
        totPaymentChecker(i) = sum(storedPayments(i,:));
    end
    
    
    
    % make pretty table
    header = [{'Period'}, names];
    T = array2table(paymentSchedule,...
        'VariableNames',header);

end