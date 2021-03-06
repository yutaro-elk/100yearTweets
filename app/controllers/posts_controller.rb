class PostsController < ApplicationController
  def index
    # Timecop.freeze(5.hours.ago)
    # Timecop.return
    # スマートじゃないからリファクタリングしたい
    posts1 = Post.created_today
    posts2 = Post.created_yesterday
    posts3 = Post.created_a_week_ago
    posts4 = Post.created_a_month_ago
    posts5 = Post.created_a_year_ago
    @posts = posts1 + posts2 + posts3 + posts4 + posts5
    
    #現在時間以前の投稿を抽出し、時間で降順にソート
    @posts = @posts
      .select do |post|
        post[:created_at].strftime('%X') <= Time.zone.now.strftime('%X')
      end
      .sort_by do |post| 
        post[:created_at].strftime('%X')
      end.reverse
    
  end

  def new
  end

  def create
    @post = Post.new(content: params[:content])
    @post.save
    if params[:image]
      @post.tweet_image = "#{@post.id}.jpg"
      image = params[:image]
      image = MiniMagick::Image.read(image)
      image.auto_orient
      image.resize "2048"
      image.strip
      image.write("public/tweet_images/#{@post.tweet_image}")
      # image.destroy!
    end
    @post.save
    redirect_to("/posts/index")
  end
end
