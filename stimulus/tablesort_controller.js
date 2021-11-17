// <table class="table table-hover table-bordered" data-controller="tablesort">
// </table>

import { Controller } from "@hotwired/stimulus"
var tablesort = require('tablesort')

export default class extends Controller {
    static targets = [ "output" ]

    connect() {
        this.initTablesort(this.element)
    }

    initTablesort(el) {
        tablesort(el, { descending: true })
    }
}
