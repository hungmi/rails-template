// <div data-controller='awesomplete' data-awesomplete-list-url-value='/items.json'>
//     <input data-awesomplete-target='input'>
// </div>

import { Controller } from "@hotwired/stimulus"
import Awesomplete from 'awesomplete'

export default class extends Controller {
    static targets = ["input", "detail"] // detailTarget 作為選定之後可連帶填寫的額外欄位
    static values = {
        listUrl: String,
        list: String
    }

    connect() {
        // this.init()
    }

    listUrlValueChanged() {
        this.init()
    }

    async init() {
        var controller = this
        if (controller.instance) {
            controller.instance.destroy()
        }
        // console.log(controller.element)
        // console.log(controller.hasListUrlValue)
        if (controller.hasListUrlValue) {
            controller.inputTarget.disabled = true // 載入前，先停用 input
            fetch(controller.listUrlValue)
                .then(response => response.json())
                .then((items) => {
                    controller.instance = new Awesomplete(controller.inputTarget, {
                        list: items,
                        minChars: 0,
                        autoFirst: true,
                        replace: function(item) {
                            // 因為後端回傳會有這樣的格式：
                                // {
                                //      label: '需要顯示的',
                                //      value: { data1: 'aaa', data2: 'bbb' }
                                // }
                                // 因此這邊要固定顯示 label 內的值
                            this.input.value = item.label
                        }
                    });
                    controller.inputTarget.disabled = false  // 載入完成，啟用 input
                    controller.inputTarget.addEventListener('focus', function() {
                        if (controller.instance) {
                            controller.instance.evaluate()
                        }
                    })
                })    
        } else {
            controller.instance = new Awesomplete(controller.inputTarget, {
                list: controller.listValue,
                minChars: 0,
                autoFirst: true,
            });
            controller.inputTarget.addEventListener('focus', function() {
                if (controller.instance) {
                    controller.instance.evaluate()
                }
            })
        }
    }
}