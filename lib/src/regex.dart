final parametersRegExp = RegExp(r'\{(.*?)\}', caseSensitive: false);
final charactersAndNumbersRegExp = RegExp(r'[^\w\s\d]+');
final repeatingSpacesRegExp = RegExp(r'\s+');
final parametersValueRegExp = RegExp(r'(?<=\{).+?(?=\})', caseSensitive: false);
final functionDefinitionRegExp = RegExp(r'Future<.*>.*\((?=.*\) async \{)');
final importRegExp = RegExp(r'import.*;');
final functionSignatureRegExp = RegExp(r'Future<.*>.*{');
final functionCommentRegExp = RegExp(r'\/\/.*');
