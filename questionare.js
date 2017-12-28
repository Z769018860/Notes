// For my dearest.
// Copyright (c) 2017 Augustus Wang

//初始化代码, 放在开头, 只用一次
window.time_array = new Array();
window.element_record = new Array();
window.multi_click = new Array();

//首页问题加载完成时
function Tempobj() {
    this.name = "start";
};
var temp = new Tempobj();
var _time = new Date();
window.time_array.push(parseInt(_time.getTime()));
window.element_record.push(temp);

//计时代码, 每个问题都放......
var click_cnt = 0;
function RecTime(event, element) {
    if (element.type == 'radio') {
        if (click_cnt < 1) {
            var _time = new Date();
            window.time_array.push(parseInt(_time.getTime()));
            window.element_record.push(element);
            console.log("Saved ", _time.getTime(), "at", element.name);
            click_cnt++;
        } else {
            window.multi_click.push(element);
            console.log("Recorded multiclick at", element.name);
        }
    }
}

this.questionclick = RecTime;

//结尾代码, 放在结尾, 只用一次
function ShowTime(event, element) {
    var result = new Array();
    console.log("------------------------------------------~~~///(^v^)");
    console.log("Time recorded:");
    for (var i = 0; i < window.time_array.length - 1; i++) {
        console.log("Time from", window.element_record[i].name, "to", window.element_record[i + 1].name, "is", window.time_array[i + 1] - window.time_array[i]);
        // alert(window.time_array[i + 1] - window.time_array[i]);
        result.push(window.time_array[i + 1] - window.time_array[i]);
    }
    console.log("=--------------------------------------=(￣▽￣)");
    console.log("Multiclick recorded:");
    for (var i = 0; i < window.multi_click.length; i++) {
        console.log("multiclick at", window.multi_click[i].name);
    }

    return result;
}

ShowTime();

