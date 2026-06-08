# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_item,       only: %i[show edit update destroy]
  before_action :load_form_data, only: %i[new edit create update]

  def index
    if params[:category_id].present?
      items = Item.includes(:category)
                   .where(category: { id: params[:category_id] })
    else
      items = Item.includes(:category).order(:name)
    end

    @items = items
    @categories = Category.order(:name)
  end

  def show
    @presenter = ItemPresenter.new(@item)
  end

  def new
    @item = Item.new
  end

  def edit; end

  def ranking
    @results = if params[:category_id].present?
                 BestItemsToSellQuery.new(
                     category_id: params[:category_id]
                   ).call
               else
                 @results = BestItemsToSellQuery.new(
                   category_id: Category.ids
                 ).call
               end

    @categories = Category.order(:name)
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to items_path, notice: "Item criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "Item atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "Item removido com sucesso."
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def load_form_data
    @categories = Category.order(:name)
    @items      = Item.order(:name)
  end

  def item_params
    params.require(:item).permit(
      :name, :preparation_time, :sale_price, :additional_cost, :category_id,
      item_components_attributes: %i[id component_item_id quantity _destroy]
    )
  end
end
