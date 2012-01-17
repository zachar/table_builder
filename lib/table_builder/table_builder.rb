module TableHelper

  def table_for(objects, *args, &block)
    raise ArgumentError, "Missing block" unless block_given?
    options = args.last.is_a?(Hash) ? args.pop : {}
    html_options = options[:html]
    builder = options[:builder] || TableBuilder

    content_tag(:table, html_options) do
      yield builder.new(objects || [], self, options)
    end
  end

  class TableBuilder
    include ::ActionView::Helpers::TagHelper

    def initialize(objects, template, options)
      raise ArgumentError, "TableBuilder expects an Array but found a #{objects.inspect}" unless objects.is_a? Array
      @objects, @template, @options = objects, template, options
    end

    def head(*args, &block)
      if block_given?
        @template.content_tag(:thead, nil, options_from_hash(args), true, &block)
      else        
        @num_of_columns = args.size
        content_tag(:thead,
          content_tag(:tr,
            args.collect { |c| content_tag(:th, c.html_safe)}.join('').html_safe
          )
        )
      end
    end

    def head_r(*args, &block)
      raise ArgumentError, "Missing block" unless block_given?
      options = options_from_hash(args)
      head do
        @template.content_tag(:tr, nil, options, true, &block)
      end
    end

    def body(*args, &block)
      raise ArgumentError, "Missing block" unless block_given?
      options = options_from_hash(args)
      content = @objects.collect do |c|
          @template.with_output_buffer{block.call(c)}
      end.join("\n").html_safe
      @template.content_tag(:tbody, content, options, false)
    end
    
    def body_r(*args, &block)
      raise ArgumentError, "Missing block" unless block_given?
      options = options_from_hash(args)
      tbody do
        @objects.each { |c|
          concat(tag(:tr, options, true))
          yield(c)
          concat('</tr>'.html_safe)
        }
      end
      content = tds.collect do |td|
          @template.content_tag(:tr,td, {}, false)
      end.join("\n").html_safe
      "\n#{@template.content_tag(:tbody, content, options, false)}".html_safe
    end    

    def r(*args, &block)
      raise ArgumentError, "Missing block" unless block_given?
      options = options_from_hash(args)
      @template.content_tag(:tr, nil, options, true, &block)
    end

    def h(*args, &block)
      if block_given?
        @template.content_tag(:th, nil, options_from_hash(args), true, &block)
      else
        content = args.shift
        @template.content_tag(:th, content, options_from_hash(args))
      end        
    end

    def d(*args, &block)
      if block_given?
        @template.content_tag(:td, nil, options_from_hash(args), true, &block)
      else
        content = args.shift
        @template.content_tag(:td, content, options_from_hash(args))
      end        
    end

    private
    
    def options_from_hash(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end
    
    def concat(tag)
      @template.safe_concat(tag)
      ""
    end

    def content_tag(tag, content, *args)
      options = options_from_hash(args)
      @template.content_tag(tag, content, options)
    end
    
    def tbody
      concat('<tbody>')
      yield
      concat('</tbody>')
    end
    
    def tr options
      concat(tag(:tr, options, true))
      yield
      concat('</tr>')      
    end
  end
end
