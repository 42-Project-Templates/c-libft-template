NAME := template

LIBS_DIR := libs
LIBFT_DIR := $(LIBS_DIR)/libft
LDFLAGS := -L$(LIBFT_DIR)
LDLIBS := -lft

INCS := include $(LIBFT_DIR)/include

SRC_DIR := src
BUILD_DIR := .build

SRCS := main.c

OBJS := $(SRCS:%.c=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

CC := gcc
CFLAGS := -Wall -Werror -Wextra
CPPFLAGS := $(addprefix -I, $(INCS)) -MMD -MP

RM := rm -rf

all: $(NAME)

debug: CFLAGS += -g -DDEBUG
debug: all

address: CFLAGS += -fsanitize=address -g
address: re

thread: CFLAGS += -fsanitize=thread -g
thread: re

print-%: ; @echo $* = $($*)

submodules:
	git submodule sync
	git submodule update --init

$(NAME): $(BUILD_DIR) $(OBJS)
	@make -sC $(LIBFT_DIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(OBJS) -o $(NAME) $(LDFLAGS) $(LDLIBS)

$(BUILD_DIR):
	@test -d $@ || mkdir -p $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

clean:
	@make -sC $(LIBFT_DIR) clean
	$(RM) $(BUILD_DIR)

fclean: clean
	@make -sC $(LIBFT_DIR) fclean
	$(RM) $(NAME)

re: fclean all

-include $(DEPS)

.PHONY: all clean fclean re debug address thread
