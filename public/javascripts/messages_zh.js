/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: TW (Taiwan - Traditional Chinese)
 */
jQuery.extend(jQuery.validator.messages, {
        required: "必填",
		remote: "请改正此项",
		email: "请输入正确的Email地址",
		url: "请输入合法的URL",
		date: "请输入合法的日期",
		dateISO: "请输入合法的日期(ISO).",
		number: "请输入数字",
		digits: "请输入整数",
		creditcard: "請輸入合法的信用卡號碼",
		equalTo: "請重複輸入一次",
		accept: "請輸入有效的後缀字串",
		maxlength: jQuery.validator.format("請輸入長度不大於{0} 的字串"),
		minlength: jQuery.validator.format("請輸入長度不小於 {0} 的字串"),
		rangelength: jQuery.validator.format("請輸入長度介於 {0} 和 {1} 之間的字串"),
		range: jQuery.validator.format("請輸入介於 {0} 和 {1} 之間的數值"),
		max: jQuery.validator.format("請輸入不大於 {0} 的數值"),
		min: jQuery.validator.format("請輸入不小於 {0} 的數值")
});