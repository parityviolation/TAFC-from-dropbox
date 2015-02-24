function [questions context] = askQuestion(questions, context)
% function askQuestion(questions)
% BA for asking questions at script
% questions is a struct see below
%
% questions.text = 'Fiber Attached (y/n):'
% questions.answerAllowEmpty = 0;
% questions.answer
% questions.answerType = 'bool'
% question(n).askIf = [1 0;] % if question 1 is 0
% question(n).askIfBox = [1:4] % if question 1 is 0
%
% can ask questions only in specific context
% context.box
% context.protocol

if nargin == 0 % initialize questions
    questions.text = '';
    questions.answerAllowEmpty = 0;
    questions.answer = '';
    questions.answerType = 'bool';
    questions.askIf = [] ;% if question 1 is 0
    questions.askIfBox = [] ;% if question 1 is 0
    questions.askIfProtocol = [];
    
    context.box  = []; % box index matching askIfBox
    context.animal  = []; % box index matching askIfBox
    context.protocol = '';
    
    return
end

if nargin<2
    context.box  = []; % box index matching askIfBox
    context.animal  = []; % box index matching askIfBox
    context.protocol = '';
end

nq = length(questions);
iq = 0;
while iq <nq
    iq = iq +1;
    baskquestion = 1;
    baskquestion = checkIfQuestionShouldBeAsked(iq,questions,context,baskquestion)  ;  
    
    
    if baskquestion
        brepeat = 0;
        thisQ = questions(iq);
        thisQ.answer = input(thisQ.text,'s');
        
        if isempty(thisQ.answer) %% can the user give no answer?
            if thisQ.answerAllowEmpty
                
            else
                disp('That is not an answer!')
                
            end
            
        else
            [thisQ brepeat]= handleAnswer(thisQ,brepeat);
        end
        
        if ~brepeat
            questions(iq) = thisQ;
        else
            iq = iq -1;
        end
    end
    
end
function [thisQ brepeat]= handleAnswer(thisQ,brepeat)

thisQ.answer = lower(thisQ.answer);
switch (thisQ.answerType)
    
    case 'bool'
        if isequal(thisQ.answer,'y')|isequal(thisQ.answer,'yes')
            thisQ.answer = 1;
        elseif isequal(thisQ.answer,'n')|isequal(thisQ.answer,'no')
            thisQ.answer = 0;
        else
            disp('must by ''y'' or ''n'' ')
            brepeat = 1;
        end
    case 'string'
        
    case 'number'
        if isstrprop(thisQ.answer, 'digit')
            thisQ.answer = str2num(thisQ.answer);
        else
            disp('must bu a number ')
            brepeat = 1;
        end
        
end

function baskquestion = checkIfQuestionShouldBeAsked(iq,questions,context,baskquestion)
% checks if 

if ~isempty(questions(iq).askIf)  % check if Question should be asked based on the history of questions
    qnumber = questions(iq).askIf(1);
    qanswer = questions(iq).askIf(2);
    if questions(qnumber).answer == qanswer
        baskquestion = 1;
    else
        baskquestion = 0;
    end
end

if baskquestion
    if ~isempty(questions(iq).askIfBox) % based on box
        if isempty(context.box)
            error('box unknown')
        end
        if any(ismember(context.box,questions(iq).askIfBox))
            baskquestion = 1;
        else
            baskquestion = 0;
        end
    end
end
if baskquestion
    if ~isempty(questions(iq).askIfAnimal) % based on box
        if isempty(context.animal)
            error('animal unknown')
        end
        if any(ismember(context.animal,questions(iq).askIfAnimal))
            baskquestion = 1;
        else
            baskquestion = 0;
        end
    end
end
if baskquestion
    if ~isempty(questions(iq).askIfProtocol) % based on protocol
        if isempty(context.protocol)
            error('protocol unknown')
        end
        
        if any(ismember(context.protocol,questions(iq).askIfProtocol))
            baskquestion = 1;
        else
            baskquestion = 0;
        end
    end
end

