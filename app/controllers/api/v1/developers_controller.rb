class  Api::V1::DevelopersController < ApplicationController
  include DevelopersHelper

  def create
    begin
      status = validate_team_api_params(params)
      if status
        team = Team.new(get_team_permit_params(params["team"]))
        if team.valid?
          team.save!
          developers_arr = construct_developer_arr(params["developers"])
          if team.developers.create!(developers_arr)
            res = {"team_id"=> team.id, "message" => "Sucessfully created team and its developers"}
            resp = generate_response res, true
            render json: resp , status: 201
          else
            error = "Error while creating team"
            error = team.errors.full_messages.first unless team.errors.blank?
            resp = generate_response error, false
            render json: resp , status: 409
          end
        else
          error = "Error while creating team"
          error = team.errors.full_messages.first unless team.errors.blank?
          resp = generate_response error, false
          render json: resp , status: 409
        end
      else
        resp = generate_response "Missing Parameter", status
        render json: resp , status: 422
      end
    rescue ActiveRecord::RecordInvalid => invalid
      error = invalid.record.errors.first.type
      resp = generate_response error, false
      render json: resp , status: 409
    rescue => e
      render json: {error: {message: "something went wrong"}}, status: 500
    end
  end

  def notify
    begin
      if params.key?("team_id")
        if Developer.exists?(team_id: params["team_id"])
          url = "https://sample.notificationservice.com"
          developer  = Developer.find_by(team_id: params[:team_id])
          sms_req_body = notify_developer(developer, params)
          status = post_sms_data(url,sms_req_body)
          if status
            res = {"from"=> sms_req_body[:from], "to" => sms_req_body[:to], "message" => "Sucessfully sent SMS" }
            resp = generate_response res, true
            render json: resp , status: 200
          else
            resp = generate_response "We are facing problem with sending SMS", false
            render json: resp , status: 503
          end
        else
          resp = generate_response "Team not found", false
          render json: resp , status: 404
        end
      else
        resp = generate_response "Team id  Parameter", false
        render json: resp , status: 422
      end
    rescue => e
      render json: {error: {message: "something went wrong"}}, status: 500
    end
  end
  private

  def validate_team_api_params(params)
    status = true
    status = false if (!params.key?("team") || !params.key?("developers"))
    status
  end

  def get_team_permit_params( team)
    team.permit(:name, :dept_name)
  end
end
