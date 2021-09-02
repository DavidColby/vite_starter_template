import { Application } from 'stimulus'
import { registerControllers } from 'stimulus-vite-helpers'
import StimulusReflex from 'stimulus_reflex'
import consumer from '../channels/consumer'

const application = Application.start()
const controllers = import.meta.globEager('./**/*_controller.js')
registerControllers(application, controllers)
StimulusReflex.initialize(application)
application.consumer = consumer
