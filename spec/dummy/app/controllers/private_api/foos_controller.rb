class PrivateApi::FoosController < SublimeVideoPrivateApiController
  before_filter :find_foo, only: [:show, :update, :destroy]

  def index
    expires_in 2.minutes, public: true
    @foos = FooServer.page(params[:page])
    respond_with(@foos)
  end

  def show
    expires_in 2.minutes, public: true
    respond_with(@foo) if stale?(@foo, public: true)
  end

  def create
    @foo = FooServer.create(params[:foo])
    respond_with(@foo)
  end

  def update
    @foo.update(params[:foo])
    respond_with(@foo)
  end

  def destroy
    @foo.destroy
    respond_with(@foo)
  end

  private

  def find_foo
    @foo = FooServer.find(params[:id])
  end
end
