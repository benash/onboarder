class App
  module Views
    class Index < Layout
      def content
        "Welcome! Mustache lives."
      end

      def tasks
        Task.update(@agent)
      end

      def complete?
        Task.all.all?(&:complete?)
      end
    end
  end
end
