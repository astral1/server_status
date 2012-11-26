(function ($) {
    var ServerModel = Backbone.Model.extend({
        url:function () {
            return '/' + this.get('name') + '/status'
        }
    });
    var ServerCollection = Backbone.Collection.extend({
        model:ServerModel,
        url:'/servers'
    });
    var ItemView = Backbone.View.extend({
        tagName:'tr',
        initialize:function () {
            _.bindAll(this, 'render');
            this.model.bind('change', this.render);
            this.nameTemplate = _.template('<td class="center"><%= name %></td>');
            this.descriptionTemplate = _.template('<td><%= description %></td>');
            this.portTemplate = _.template('<td class="center"><i class="icon-<%= port %>"/></td>');
            this.apiTemplate = _.template('<td class="center"><i class="icon-<%= api %>"/> <span class="label label-<%= label %>"><%= code %></span></td>')
            this.template = _.template('<td class="center"><i class="icon-<%= api %>"/> <span class="label label-<%="></span></td>');
        },
        render:function () {
            var nameMarkup = this.nameTemplate({name:this.model.get('name')});
            var descriptionMarkup = this.descriptionTemplate({description:this.model.get('description')});
            var portMarkup = '<td></td>';
            var apiMarkup = '<td></td>';
            if (this.model.has('is_open')) {
                var isOpen = this.model.get('is_open');
                portMarkup = this.portTemplate({port:isOpen ? 'ok' : 'remove'});
            }
            if (this.model.has('code')) {
                var isLive = this.model.get('code') == 200;
                apiMarkup = this.apiTemplate({api:isLive ? 'ok' : 'remove', code:this.model.get('code'), label:isLive ? 'success' : 'important'});
            }

            if (this.model.has('is_open') && this.model.has('code')) {
                $(this.el).attr('class', isLive && isOpen ? 'success' : 'error');
            }
            $(this.el).html([nameMarkup, descriptionMarkup, portMarkup, apiMarkup].join());
            return this;
        },
        update:function () {
            this.model.fetch({success:this.render});
        }
    });
    var CollectionView = Backbone.View.extend({
        el:$('table.server tbody'),
        initialize:function () {
            _.bindAll(this, 'render', 'append');
            this.fetched = false;
            this.collection = new ServerCollection();
            this.childViews = {};
            this.collection.bind('add', this.append);
            this.collection.bind('change', this.render);
            this.collection.fetch({
                success:_.bind(this.render, this)
            });
        },
        render:function () {
            var self = this;
            this.collection.models.forEach(_.bind(function (item) {
                var keys = _.keys(self.childViews);
                if (!_.contains(keys, item.get('name'))) {
                    self.append(item);
                }
            }, self));
            this.fetched = true;
        },
        append:function (item) {
            var itemView = new ItemView({model:item});
            $(this.el).append(itemView.render().el);
            this.childViews[item.get('name')] = itemView;
        },
        update:function () {
            if (!this.fetched) {
                _.delay(_.bind(this.update, this), 300);
                return;
            }
            this.collection.models.forEach(function (item) {
                item.fetch();
            });
        }
    });

    var serverView = new CollectionView();
    serverView.update();
    setInterval(function () {
        serverView.update();
    }, 3000);
})(jQuery);
