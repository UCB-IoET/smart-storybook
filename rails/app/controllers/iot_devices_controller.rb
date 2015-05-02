class IotDevicesController < ApplicationController
  helper IotDevicesHelper
  before_action :set_iot_device, only: [:show, :edit, :update, :destroy]

  # GET /iot_devices
  # GET /iot_devices.json
  def index
    @iot_devices = IotDevice.all
  end

  # GET /iot_devices/1
  # GET /iot_devices/1.json
  def show
  end

  # GET /iot_devices/new
  def new
    @iot_device = IotDevice.new
  end

  # GET /iot_devices/1/edit
  def edit
  end

  # POST /iot_devices
  # POST /iot_devices.json
  def create
    @iot_device = IotDevice.new(iot_device_params)

    respond_to do |format|
      if @iot_device.save
        format.html { redirect_to @iot_device, notice: 'Iot device was successfully created.' }
        format.json { render action: 'show', status: :created, location: @iot_device }
      else
        format.html { render action: 'new' }
        format.json { render json: @iot_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /iot_devices/1
  # PATCH/PUT /iot_devices/1.json
  def update
    respond_to do |format|
      if @iot_device.update(iot_device_params)
        format.html { redirect_to @iot_device, notice: 'Iot device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @iot_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /iot_devices/1
  # DELETE /iot_devices/1.json
  def destroy
    @iot_device.destroy
    respond_to do |format|
      format.html { redirect_to iot_devices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iot_device
      @iot_device = IotDevice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def iot_device_params
      params.require(:iot_device).permit(:uuid, :actuator_type, :metadata, :last_seen)
    end
end
