function test_env

setenv('TESTVAR','TESTVAR Hello');
val1 = getenv('TESTVAR');
val2 = getenv('MCR_CACHE_ROOT');

disp(['TESTVAR: ' val1])
disp(['MCR_CACHE_ROOT: ' val2])
