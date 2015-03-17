
// replace the define call with a shim that records all defined modules that end with
// 'tests' as these are our test modules
var testModules = [];
_oldDefine = define;
define = function() {
    var mod = arguments[0];
    if (/tests$/.test(mod)) {
        testModules.push(mod);
    }
    _oldDefine.apply(this, arguments);
}


// after window load (i.e. when all other scripts with modules have had a chance to load)
// ask Karma to run all loaded test modules
window.addEventListener("load", function() {

    require.config({
        // Karma serves files under /base, which is the basePath from your config file
        baseUrl: '/base',

        // dynamically load all test files
        deps: testModules,

        // we have to kickoff jasmine, as it is asynchronous
        callback: function() {
            //debugger;
            window.__karma__.start()
        }
    });

})