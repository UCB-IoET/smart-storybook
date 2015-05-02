class SimulatorController < ApplicationController
  def actuate
  	@iot_device = IotDevice.find(params[:iot_device_id])
  	@action = @iot_device.metadata["actions"][params[:action_id].to_i];
  end
end
