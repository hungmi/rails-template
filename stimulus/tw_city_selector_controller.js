import TwCitySelector from 'tw-city-selector/dist/tw-city-selector.min.js'
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = [ "" ]

	connect() {
		let controller = this
		new TwCitySelector({
			el: '.city-selector-set',
			elCounty: '.county',
			elDistrict: '.district',
			elZipcode: '.zipcode',
			hasZipcode: !!controller.element.querySelector('.zipcode'),
			countyFieldName: controller.element.getAttribute('data-county-name'),
			districtFieldName: controller.element.getAttribute('data-district-name'),
		});
	}
}

// <div class="mb-3">
//   	<%= f.label :address, class: 'form-label' %>
//   	<div data-controller="tw-city-selector" class="row city-selector-set" data-county-name="<%= resource_name %>[city]" data-district-name="<%= resource_name %>[district]">
//     	<div class="col pe-0">
//       		<select style="background-position: right .5rem center; padding-right: 1.5rem;" class="county form-select <%= f.object.errors[:city].present? ? 'is-invalid' : '' %>" data-value="<%= f.object.city %>"></select>
//       		<% if f.object.errors[:city].present? %>
//         		<div class="invalid-feedback">
//           			<%= f.object.errors[:city].join(", ") %>
//         		</div>
//       		<% end %>
//     	</div>
//     	<div class="col px-0">
//       		<select style="background-position: right .5rem center; padding-right: 1.5rem;" class="district form-select <%= f.object.errors[:district].present? ? 'is-invalid' : '' %>" data-value="<%= f.object.district %>"></select>
//       		<% if f.object.errors[:district].present? %>
//         		<div class="invalid-feedback">
//           			<%= f.object.errors[:district].join(", ") %>
//         		</div>
//       		<% end %>
//     	</div>
//     	<div class="col ps-0">
//       		<input name="<%= resource_name %>[zipcode]" class="zipcode form-control" type="text" size="3" readonly placeholder="郵遞區號" data-value="<%= f.object.zipcode %>">
//     	</div>
//   	</div>

//   	<%= f.text_area :address, class: "form-control #{f.object.errors[:address].present? ? 'is-invalid' : ''}" %>
//   	<% if f.object.errors[:address].present? %>
//     	<div class="invalid-feedback">
//       		<%= f.object.errors[:address].join(", ") %>
//     	</div>
//   	<% end %>
// </div>