function publishWithStandardExample(fn)
    arguments
        fn (1,:) char
    end
    if strcmp(fn((end-1):end), '.m')
        fn = fn(1:(end-2));
    end
    fprintf('publishing %s\n',fn);
    publish([fn,'.m'],'evalCode',true,'showCode',false,'codeToEvaluate',strcat('runExample(''Example',fn,''')'));
end