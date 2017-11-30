class Api::V1::ReservationsController < ApiController
  before_action :authenticate_user!, :only => [:index]
  def create
    @train = Train.find_by_number!(params[:train_number])
    @reservation = Reservation.new( :train_id => @train.id,
                                    :seat_number => params[:seat_number],
                                    :customer_name => params[:customer_name],
                                    :customer_phone => params[:customer_phone])
    @reservation.user = current_user
    if @reservation.save
      render :json =>{ :booking_code => @reservation.booking_code,
                       :reservation_url => api_v1_reservation_url(@reservation.booking_code) }
    else
      render :json => { :message=>"订票失败",:errors => @reservation.errors },:status => 400
    end
  end

  def index
    @reservations = current_user.reservations
    render :json => {
      :data => @reservations.map { |reservation|
        {
          :booking_code => reservation.booking_code,
          :train_number => reservation.train.number,
          :seat_number => reservation.seat_number,
          :customer_name => reservation.customer_name,
          :customer_phone => reservation.customer_phone
        }

      }
    }

  end

  def show
    @reservation = Reservation.find_by_booking_code!( params[:booking_code])
    render :json => {
      :booking_code => @reservation.booking_code,
      :train_number => @reservation.train.number,
      :seat_number => @reservation.seat_number,
      :customer_name => @reservation.customer_name,
      :customer_phone => @reservation.customer_phone
    }
  end

  def update
    @reservation = Reservation.find_by_booking_code!( params[:booking_code])
    @reservation.update( :seat_number => params[:seat_number] )
    render :json => { :message => "更新成功"}
  end

  def destroy
    @reservation = Reservation.find_by_booking_code!( params[:booking_code])
    @reservation.destroy
    render :json => { :message => "成功删除"}

  end
end
