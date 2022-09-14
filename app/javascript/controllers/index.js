// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import PostViewController from "./post_view_controller"
application.register("post-view", PostViewController)

import SearchFormController from "./search_form_controller"
application.register("search-form", SearchFormController)

import TurboModalController from "./turbo_modal_controller"
application.register("turbo-modal", TurboModalController)
