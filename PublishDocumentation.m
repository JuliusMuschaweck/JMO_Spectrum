publishWithStandardExample('AddSpectra.m');
publishWithStandardExample('AddWeightedSpectra.m');

publish('JMOSpectrumLibrary.m','evalCode',true,'showCode',true)


function publishWithStandardExample(fn)
        publish(fn,'evalCode',true,'showCode',false,'codeToEvaluate',strcat('runExample(''',fn,''')'));
end