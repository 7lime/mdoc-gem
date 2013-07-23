module Mdoc
  class Processor
    # add processors apply before self
    def pre_processors
      []
    end

    # apply those processors after self
    def post_processors
      []
    end

    # do the real jobs, raise for errors
    def process!(document); end

    # by default, can not perform more than one times for a single document
    def repeatable?
      false
    end
  end
end
